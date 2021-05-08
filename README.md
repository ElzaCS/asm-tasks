# asm-tasks
Exercises of microprocessors and microcontrollers lab

## TASM Commands in terminal
- compile: `tasm <file_name>.asm`
- link: `tlink <file_name>`
- debug: `td <file_name>`
- execute: `<file_name>`

## Running project
### Keil MicroVision
- Set Options for Target:
  - Target: 'Xtal(Mhz) = 12 (approx)'
  - Output: 
    - for asm file: Enable 'Create Executable' and 'Create HEX file'
    - for c file: Enable './Objects/<file>:LIB'
  - Debug: 
    - for asm file: Disable 'Run to main()' in left column
    - for c file: Enable 'Run to main()' in left column
- Translate -> Build -> Rebuild
### Proteus
- for new project: 'Schematic capture' or open project
- some extra security access setup to give all permissions of project folder to user
- Add HEX file: Right-click on a circuit device->'Edit properties'->'Program File'
- Start simulation: 'Debug'->'Run simulation'
